//==============================================================================
// lpi_qchannel_coverage.sv
// Functional coverage : interface states and legal edges.
//==============================================================================
class lpi_qchannel_coverage extends uvm_subscriber #(lpi_qchannel_item);
  `uvm_component_utils(lpi_qchannel_coverage)
  lpi_qchannel_item tr;

  covergroup cg;
    option.per_instance = 1;
    cp_prev : coverpoint tr.prev_state { bins s[] = {Q_RUN,Q_REQUEST,Q_STOPPED,Q_EXIT,Q_DENIED,Q_CONTINUE}; }
    cp_curr : coverpoint tr.curr_state { bins s[] = {Q_RUN,Q_REQUEST,Q_STOPPED,Q_EXIT,Q_DENIED,Q_CONTINUE}; }
    x_edge  : cross cp_prev, cp_curr {
      bins run_req  = binsof(cp_prev) intersect {Q_RUN}      && binsof(cp_curr) intersect {Q_REQUEST};
      bins req_stop = binsof(cp_prev) intersect {Q_REQUEST}  && binsof(cp_curr) intersect {Q_STOPPED};
      bins req_den  = binsof(cp_prev) intersect {Q_REQUEST}  && binsof(cp_curr) intersect {Q_DENIED};
      bins stop_ex  = binsof(cp_prev) intersect {Q_STOPPED}  && binsof(cp_curr) intersect {Q_EXIT};
      bins ex_run   = binsof(cp_prev) intersect {Q_EXIT}     && binsof(cp_curr) intersect {Q_RUN};
      bins den_cont = binsof(cp_prev) intersect {Q_DENIED}   && binsof(cp_curr) intersect {Q_CONTINUE};
      bins cont_run = binsof(cp_prev) intersect {Q_CONTINUE} && binsof(cp_curr) intersect {Q_RUN};
      ignore_bins others = !(binsof(x_edge.run_req)  || binsof(x_edge.req_stop) ||
                             binsof(x_edge.req_den)  || binsof(x_edge.stop_ex)  ||
                             binsof(x_edge.ex_run)   || binsof(x_edge.den_cont) ||
                             binsof(x_edge.cont_run));
    }
  endgroup

  function new(string name, uvm_component parent);
    super.new(name,parent); cg = new();
  endfunction
  function void write(lpi_qchannel_item t); tr = t; cg.sample(); endfunction
endclass
