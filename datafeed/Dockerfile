FROM julia

WORKDIR /app

COPY . .

ENV HOST "0.0.0.0"

RUN julia --project -e "import Pkg; Pkg.instantiate(); Pkg.precompile()"

CMD julia --project src/datafeed.jl 8081
