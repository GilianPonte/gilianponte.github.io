<div id="full-turn-tunnel" style="height:500px;position:relative;background:#000;overflow:hidden;color:#00ff00;font:12px 'Courier New',monospace">
  <style>
    #full-turn-tunnel canvas{width:100%;height:100%;display:block}
    #full-turn-tunnel .ftt-msg{
      position:absolute;top:0;left:0;z-index:2;
      white-space:nowrap;
      font-size:clamp(11px,2.4vw,17px);
      font-weight:bold;
      text-shadow:0 0 9px #00ff00;
      pointer-events:none;
      will-change:transform,opacity;
    }
    #full-turn-tunnel button{
      border:1px solid #00ff00;
      background:#000;
      color:#00ff00;
      padding:8px 12px;
      font:11px monospace;
      cursor:pointer;
    }
    #full-turn-tunnel .ftt-skip{
      position:absolute;right:12px;top:12px;z-index:4
    }
    #full-turn-tunnel .ftt-end{
      display:none;position:absolute;inset:0;background:#000;
      text-align:center;padding:100px 20px
    }
    #full-turn-tunnel .ftt-replay{margin-top:32px}
  </style>

  <canvas aria-label="Fast green 3D tunnel with left right and up down turns"></canvas>
  <div class="ftt-msg ftt-location">LOCATION: NOT DETERMINED</div>
  <div class="ftt-msg ftt-language"></div>
  <button class="ftt-skip">SKIP →</button>

  <div class="ftt-end">
    <div style="font-size:24px">Gilian Ponte_</div>
    <p style="margin-top:24px">Research · Food · Music</p>
    <p>WELCOME TO MY WEBSITE_</p>
    <button class="ftt-replay">↻ REPLAY</button>
  </div>
</div>

<script>
(()=>{
  const root=document.getElementById('full-turn-tunnel');
  if(root.dataset.ready)return;
  root.dataset.ready='1';

  const canvas=root.querySelector('canvas');
  const ctx=canvas.getContext('2d');
  const loc=root.querySelector('.ftt-location');
  const lang=root.querySelector('.ftt-language');
  const end=root.querySelector('.ftt-end');
  const skip=root.querySelector('.ftt-skip');
  const reducedMotion = window.matchMedia(
  "(prefers-reduced-motion: reduce)"
);

if (reducedMotion.matches) {
  root.remove();
  return;
}

  lang.textContent='LANGUAGE: '+(navigator.language||'UNKNOWN');

  const TAU=Math.PI*2;
  const POINTS=24;
  const LENGTH=28;
  const SPEED=30;      // faster forward motion
  const DURATION=10800;

  let active=false,startTime=0,raf=0;

  
function finish() {
  active = false;
  cancelAnimationFrame(raf);

  // Remove the animation and reveal the real homepage.
  root.remove();
}


  function start(){
    cancelAnimationFrame(raf);
    active=true;
    startTime=0;
    canvas.style.display='block';
    loc.style.display='block';
    lang.style.display='block';
    skip.style.display='block';
    end.style.display='none';

    if(matchMedia('(prefers-reduced-motion: reduce)').matches){
      finish();
      return;
    }
    raf=requestAnimationFrame(draw);
  }

  function draw(now){
    if(!active||!root.isConnected)return;
    if(!startTime)startTime=now;

    const elapsed=now-startTime;
    const t=elapsed/1000;
    const w=root.clientWidth;
    const h=root.clientHeight;
    const dpr=Math.min(devicePixelRatio||1,2);

    if(canvas.width!==Math.round(w*dpr)||canvas.height!==Math.round(h*dpr)){
      canvas.width=Math.round(w*dpr);
      canvas.height=Math.round(h*dpr);
    }

    ctx.setTransform(dpr,0,0,dpr,0,0);
    ctx.fillStyle='#000';
    ctx.fillRect(0,0,w,h);

    const cx=w/2;
    const cy=h/2;
    const rad=Math.min(w,h)*0.52;
    const focal=3.9;
    const travel=t*SPEED;

    function curveX(z){
      const world=travel+z;
      const nowX=Math.sin(travel*0.11)*2.7 + Math.sin(travel*0.045+1.6)*1.4;
      const thenX=Math.sin(world*0.11)*2.7 + Math.sin(world*0.045+1.6)*1.4;
      return (thenX-nowX)*Math.min(w,h)*0.22;
    }

    function curveY(z){
      const world=travel+z;
      const nowY=Math.cos(travel*0.09+0.7)*2.2 + Math.sin(travel*0.038+2.3)*1.2;
      const thenY=Math.cos(world*0.09+0.7)*2.2 + Math.sin(world*0.038+2.3)*1.2;
      return (thenY-nowY)*Math.min(w,h)*0.18;
    }

    function project(z,a){
      const p=focal/(z+focal);
      const r=rad*p*3.25;
      const shiftX=curveX(z)*p*2.15;
      const shiftY=curveY(z)*p*2.15;
      return [
        cx+shiftX+Math.cos(a)*r,
        cy+shiftY+Math.sin(a)*r*0.86
      ];
    }

    const rot=Math.sin(t*0.9)*0.025;

    // longitudinal lines
    for(let k=0;k<POINTS;k++){
      const a=k*TAU/POINTS+rot;
      ctx.beginPath();
      for(let j=0;j<=58;j++){
        const z=LENGTH-j*(LENGTH-0.18)/58;
        const p=project(z,a);
        if(j===0) ctx.moveTo(p[0],p[1]);
        else ctx.lineTo(p[0],p[1]);
      }
      ctx.strokeStyle='rgba(0,255,0,0.66)';
      ctx.lineWidth=1.2;
      ctx.stroke();
    }

    // rings rushing toward the viewer
    for(let i=0;i<50;i++){
      const z=0.18+((i*0.55-travel)%LENGTH+LENGTH)%LENGTH;
      const opacity=0.18+0.82*(1-z/LENGTH);
      ctx.strokeStyle='rgba(0,255,0,'+opacity+')';
      ctx.lineWidth=z<3?1.9:1;

      ctx.beginPath();
      for(let j=0;j<=84;j++){
        const a=j*TAU/84+rot;
        const p=project(z,a);
        if(j===0) ctx.moveTo(p[0],p[1]);
        else ctx.lineTo(p[0],p[1]);
      }
      ctx.stroke();
    }

    // flying messages
    [
      {el:loc,delay:0.7,x:-0.28,y:-0.22,r:-8},
      {el:lang,delay:4.6,x:0.27,y:0.22,r:7}
    ].forEach(m=>{
      const p=(t-m.delay)/4.8;
      if(p<0||p>1){
        m.el.style.opacity='0';
        return;
      }

      const ease=p*p*(3-2*p);
      const s=0.1+1.75*ease;
      const x=cx+m.x*w*s+curveX(6)*0.26;
      const y=cy+m.y*h*s+curveY(6)*0.26;

      m.el.style.transform=
        `translate(-50%,-50%) translate3d(${x}px,${y}px,0) rotate(${m.r*ease}deg) scale(${0.32+1.52*ease})`;

      m.el.style.opacity=String(Math.max(0,Math.min(1,p*5,(1-p)*4)));
    });

    if(elapsed>=DURATION){
      finish();
      return;
    }

    raf=requestAnimationFrame(draw);
  }

  skip.onclick=finish;
  root.querySelector('.ftt-replay').onclick=start;

  start();
})();
</script>
