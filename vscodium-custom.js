// === NOTICE ===
// This is all ChatGPT code. All of it.

document.body.addEventListener('keydown', (e) => {
    // ctrl+s flashbang
    if ((e.metaKey || e.ctrlKey) && e.key === 's') {
        const pulse = document.createElement('div');
        Object.assign(pulse.style, {
            position: 'fixed',
            top: 0,
            left: 0,
            width: '100%',
            height: '100%',
            background: 'rgba(255,255,255,0.07)',
            pointerEvents: 'none',
            zIndex: 9999,
            animation: 'savePulse 0.3s ease-out'
        });
        pulse.addEventListener('animationend', () => pulse.remove());
        document.body.appendChild(pulse);
    }

    // keystroke visualizer
    const s = document.createElement('div');
    s.textContent = e.key.length === 1 ? e.key : `[${e.key}]`;

    Object.assign(s.style, {
        position: 'fixed',
        right: '20px',
        bottom: '20px',
        fontSize: '28px',
        fontFamily: 'Terminess Nerd Font',
        color: '#888',
        background: 'rgba(0,0,0,0.6)',
        padding: '8px 12px',
        borderRadius: '8px',
        zIndex: 10000,
        pointerEvents: 'none',
        opacity: '1',
        transition: 'all 0.8s ease-out',
    });

    document.body.appendChild(s);

    setTimeout(() => {
        s.style.opacity = '0';
        s.style.transform = 'translateY(10px)';
    }, 10);
    setTimeout(() => s.remove(), 1000);
});

// == SMOOTH CURSOR COMET v2 ==========================================
(() => {
    const lifetime = 350;  // ms point visibility
    const maxW     = 5;    // px head width

    const cvs = Object.assign(document.createElement('canvas'), {
        style: 'position:fixed;inset:0;pointer-events:none;z-index:9999'
    });
    document.body.appendChild(cvs);
    const ctx = cvs.getContext('2d');
    const pts = [];

    addEventListener('resize', () => (cvs.width = innerWidth, cvs.height = innerHeight));
    dispatchEvent(new Event('resize'));

    addEventListener('mousemove', e => pts.push({x:e.clientX, y:e.clientY, t:performance.now()}));

    const mid = (p,q) => ({x:(p.x+q.x)/2, y:(p.y+q.y)/2});

    (function draw(now){
        // prune old points
        while (pts.length && now - pts[0].t > lifetime) pts.shift();

        ctx.clearRect(0,0,cvs.width,cvs.height);

        if (pts.length > 1){
            // replace the old stroke loop with this small tweak
            ctx.lineJoin = 'round';   // smooth corners
            ctx.lineCap  = 'butt';    // flat ends – no round blobs

            for (let i = 0; i < pts.length - 1; i++) {
                const p0 = i ? mid(pts[i-1], pts[i]) : pts[i];
                const p1 = pts[i];
                const p2 = mid(pts[i], pts[i+1]);

                const age   = (now - p1.t) / lifetime;
                const w     = maxW * (1 - age);
                const a     = 0.6   * (1 - age);

                ctx.strokeStyle = `rgba(136,136,136,${a})`;
                ctx.lineWidth   = w;

                ctx.beginPath();
                ctx.moveTo(p0.x, p0.y);
                ctx.quadraticCurveTo(p1.x, p1.y, p2.x, p2.y);
                ctx.stroke();
            }
        }
        requestAnimationFrame(draw);
    })(performance.now());
})();



// weird ass css shit
const pulseStyle = document.createElement('style');
pulseStyle.textContent = `
@keyframes savePulse {
    0% { opacity: 1; }
    100% { opacity: 0; }
}`;
document.head.appendChild(pulseStyle);