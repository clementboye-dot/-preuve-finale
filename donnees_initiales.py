from skyfield.api import load

ts = load.timescale()
t = ts.tt(2026, 1, 1)  # Même date pour tous tes astres

planets = load('de421.bsp')

astres = {
    'sun': planets['sun'],
    'mercury': planets['mercury'],
    'venus' : planets['venus'],
    'terre' : planets['earth'],
    'lune' : planets['moon'],
    'mars': planets['mars'],
    'jupiter': planets['jupiter barycenter'],
    'saturne': planets['saturn barycenter'],
    'uranus' : planets['uranus barycenter'],
    'neptune' : planets['neptune barycenter'],
    'pluton' : planets['pluto barycenter']
    
}

for nom, corps in astres.items():
    pos = corps.at(t).position.m
    vel = corps.at(t).velocity.m_per_s
    print(f"{nom}:")
    print(f"  position: ({pos[0]}, {pos[1]}, {pos[2]})")
    print(f"  vitesse:  ({vel[0]}, {vel[1]}, {vel[2]})")