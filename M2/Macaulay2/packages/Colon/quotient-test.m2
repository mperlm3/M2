TEST ///
  R  = ZZ[x, y];
  I  = ideal(6*x^3, 9*x*y, 8*y^2);
  J1 = ideal(-3, x^2);
  J2 = ideal(4*y);
  assert(intersect(I:J1, I:J2) == ideal(8*y^2, 3*x*y, x*y^2, 6*x^3))
  assert(I : (J1+J2) == ideal(8*y^2, 3*x*y, 6*x^3))
  for strategy in {Quotient, Iterate} do
  assert(quotient(I, J1, Strategy => strategy) == ideal(8*y^2, 3*x*y, x*y^2, 6*x^3))
///

TEST ///
  -- quotient(Ideal,Ideal)
  -- quotient(Ideal,RingElement)
  -- options to test: DegreeLimit, BasisElementLimit, PairLimit,
  --    MinimalGenerators,
  --    Strategy=>Iterate, Strategy=>Linear
  R = ZZ/101[a..d]
  I1 = monomialCurveIdeal(R, {1,3,7})
  I2 = ideal((gens I1)_{0,1})
  I3 = quotient(I2,I1)
  I4 = quotient(I2,I3)
  I5 = quotient(I2, c)

  assert(I2 ==
       intersect(I3,I4)
       )

  assert(ideal(c,d) ==
       quotient(I2, I5)
       )

  assert(I3 ==
       I2 : I1
       )

--  assert(ideal(d) + I2 ==
--       quotient(I2,I1,DegreeLimit=>1)
--       )

  assert(I3 ==
       quotient(I2,I1,Strategy=>Iterate)
       )

  quotient(I2,I1,MinimalGenerators=>false)
--  stderr << \"  -- this fails currently\" << endl
--  assert(I5 ==
--       quotient(I2, c,Strategy=>Linear)
--       )
///

TEST ///
  -- quotient(Ideal,Ideal)
  -- quotient(Ideal,RingElement)
  -- options to test: DegreeLimit, BasisElementLimit, PairLimit,
  --    MinimalGenerators,
  --    Strategy=>Iterate, Strategy=>Linear
  R = ZZ/101[vars(0..3)]/(a*d)
  I1 = ideal(a^3, b*d)
  I2 = ideal(I1_0)

  I3 = quotient(I2,I1)
  assert(I3 == ideal(a))
  I4 = quotient(I2,I3)
  assert(I4 == ideal(a^2,d))
  I5 = quotient(I2, d)
  assert(I5 == ideal(a))
///

TEST ///
  --    quotient(Module,RingElement)
  --    quotient(Module,Ideal)

  -- This tests 'quotmod0' (default)
  R = ZZ/101[vars(0..4)]/e
  m = matrix{{a,c},{b,d}}
  M = subquotient(m_{0}, a^2**m_{0} | a*b**m_{1})
  J = ideal(a)
  Q1 = quotient(M,J)

  -- Now try the iterative version
  Q2 = quotient(M,J,Strategy=>Iterate)
  assert(Q1 == Q2)

  m = gens M
  F = target m
  mm = generators M | relations M
  j = transpose gens J
  g = (j ** F) | (target j ** mm)
  h = syz gb(g,
	  Strategy=>LongPolynomial,
	  SyzygyRows=>numgens F,
	  Syzygies=>true)
  trim subquotient(h % M.relations,
             M.relations)

///

TEST ///
  --    quotient(Module,Module)
  R = ZZ/101[a..d]
  M = image matrix{{a,b},{c,d}}
  N = super M
  I = quotient(M,N)
  assert(I ==
            quotient(M,N,Strategy=>Iterative)
	)

  assert(I ==
            M : N
	)
  assert(I ==
            ann(N/M)
	)
///

TEST ///
  --    quotient(Module,Module)
  R = ZZ/101[vars(0..14)]
  N = coker genericMatrix(R,a,3,5)
  M = image N_{}
  I = quotient(M,N)
  assert(I ==
            quotient(M,N,Strategy=>Iterative)
	)

  assert(I ==
            M : N
	)
  assert(I ==
            ann(N/M)
	)
///

TEST ///
  R = ZZ/101[a..d]
  M = coker matrix{{a,b},{c,d}}
  m1 = basis(2,M)
  image m1
  M1 = subquotient(matrix m1, relations M)
  Q1 = M1 : a
  Q2 = quotient(M1,ideal(a,b,c,d),Strategy=>Iterate)
  assert(Q1 == Q2)
///

TEST ///
  R = ZZ/101[a..d]
  mrels = matrix{{a,b},{c,d}}
  mgens = matrix(R,{{1,0},{0,0}})
  M = trim subquotient(mgens, mrels)
  Q1 = quotient(image M_{},a*d-b*c)
  assert(Q1 == super M)  -- fails: bug in == ...
///

TEST ///
  -- Test of stopping conditions
  R = QQ[a..d]
  I = ideal(a^5,b^5,c^5,d^5)
  I : (a+b+c+d)
  quotient(I, a^2+b^2+c^2+d^2, DegreeLimit=>20)
  gbTrace=3
  quotient(I, a+b+c+d, BasisElementLimit=>5, MinimalGenerators=>false)
///
