
# Our movement is based on axis-independant projectile motion equations
# First we have our given gravitational constant `g`, integrating this will yield our velocity at a given `t`
"""
⌠
| g dt = gt + v₀
⌡

constant of integration=v₀ (initial velocity)
"""
# To attain position at a given `t` we need to integrate again
"""
⌠              1
| gt + v₀ dt = ─ gt² + v₀t + p₀
⌡              2

constant of integration=p₀ (initial position)
"""

# This gives us our formula for our projectile
"""
       1
f(t) = ─ gt² + v₀t + p₀
       2
where v₀=initial velocity, p₀=initial position

∴ f(x) = ax² + bx + c
where x=t, a=g/2, b=v₀, c=p₀
"""

# Now that we know that our projectile is simply a quadratic parabola, we can solve for the y-axis movement:
# First we solve for our initial velocity v0 (v0=initial velocity, g=gravity, t=time, tₕ=time at peak)
"""
f'(t) = gt + v₀
f'(tₕ) = 0 ∵ the peak is defined as having no velocity
∴ 0 = gtₕ + v₀
∴ v₀ = -gtₕ
"""

# Our initial velocity depends on our gravity, let's solve for that
"""
known values: v₀ = -gtₕ, p₀ = 0

       1
f(t) = ─ gt² + v₀t + p₀
       2

f(tₕ) = h

      1
∴ h = ─ gtₕ² + v₀tₕ + p₀
      2

      1
∴ h = ─ gtₕ² + (-gtₕ)tₕ + 0
      2

        1
∴ h = - ─ gtₕ²
        2

      -2h
∴ g = ────
       tₕ²
"""

# Now we can solve for our initial velocity
"""
v₀ = -gtₕ

    -2h
g = ────
     tₕ²

         -2h
∴ v₀ = -(────)tₕ
          tₕ²

       2h
∴ v₀ = ──
       t
"""
