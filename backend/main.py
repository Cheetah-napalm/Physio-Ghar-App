from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="PhysioGhar API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class SessionNote(BaseModel):
    id: str
    date: str
    note: str
    exercises: List[str]
    next_session_plan: str

class SessionNoteCreate(BaseModel):
    date: str
    note: str
    exercises: List[str]
    next_session_plan: str

class Patient(BaseModel):
    id: str
    name: str
    condition: str
    age: int
    gender: str
    contact: str
    last_session_date: str
    treatment_history: List[str]
    session_notes: List[SessionNote]

class TherapistProfile(BaseModel):
    name: str
    specialization: str
    email: str
    phone: str
    experience: str
    address: str
    image_url: str

therapist_db = TherapistProfile(
    name="Dr. Suman Shrestha",
    specialization="Orthopedic Physiotherapist",
    email="suman.physio@example.com",
    phone="+977 9841234567",
    experience="6+ Years Experience",
    address="Kathmandu, Nepal",
    image_url="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500"
)

patients_db = [
    Patient(
        id="1",
        name="Ram Bahadur",
        condition="Lower Back Pain",
        age=42,
        gender="Male",
        contact="+977 9801112233",
        last_session_date="10 Sept 2026",
        treatment_history=["Initial assessment done", "Lumbar traction applied"],
        session_notes=[
            SessionNote(
                id="note_1",
                date="10 Sept 2026",
                note="Patient reported reduced stiffness in the lower back.",
                exercises=["Pelvic tilts", "Cat-cow stretch"],
                next_session_plan="Introduce core strengthening planks."
            )
        ]
    )
]

@app.get("/")
def read_root():
    return {"message": "Welcome to PhysioGhar Backend API!"}

@app.get("/profile", response_model=TherapistProfile)
def get_profile():
    return therapist_db

@app.put("/profile", response_model=TherapistProfile)
def update_profile(updated_profile: TherapistProfile):
    global therapist_db
    therapist_db = updated_profile
    return therapist_db

@app.get("/patients", response_model=List[Patient])
def get_patients():
    return patients_db

@app.get("/patients/{patient_id}", response_model=Patient)
def get_patient(patient_id: str):
    patient = next((p for p in patients_db if p.id == patient_id), None)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    return patient

@app.post("/patients/{patient_id}/notes", response_model=SessionNote)
def add_session_note(patient_id: str, note_data: SessionNoteCreate):
    patient = next((p for p in patients_db if p.id == patient_id), None)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
    
    new_note = SessionNote(
        id=str(len(patient.session_notes) + 1),
        date=note_data.date,
        note=note_data.note,
        exercises=note_data.exercises,
        next_session_plan=note_data.next_session_plan
    )
    
    patient.session_notes.insert(0, new_note)
    patient.last_session_date = note_data.date
    return new_note

@app.put("/patients/{patient_id}/notes/{note_id}", response_model=SessionNote)
def update_session_note(patient_id: str, note_id: str, note_data: SessionNoteCreate):
    patient = next((p for p in patients_db if p.id == patient_id), None)
    if not patient:
        raise HTTPException(status_code=404, detail="Patient not found")
        
    note = next((n for n in patient.session_notes if n.id == note_id), None)
    if not note:
        raise HTTPException(status_code=404, detail="Session note not found")
        
    note.date = note_data.date
    note.note = note_data.note
    note.exercises = note_data.exercises
    note.next_session_plan = note_data.next_session_plan
    
    return note