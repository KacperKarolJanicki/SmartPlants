from pydantic import BaseModel, Field

class PompsWorkflow(BaseModel):
    n_pomp_time: int = Field(description="Azot")
    p_pomp_time: int = Field(description="Fosfor")
    k_pomp_time: int = Field(description="Potas")
    w_pomp_time: int = Field(description="Czysta woda")