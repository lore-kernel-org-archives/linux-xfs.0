Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ODI3mn081300 for <xfs@oss.sgi.com>; Wed, 24 Jun 2009 08:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <200906241440.52272@zmi.at>
References: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>
	<200906241440.52272@zmi.at>
Date: Wed, 24 Jun 2009 18:48:27 +0530
Message-ID: <409bd82b0906240618s7434748evc25e0b16f7f2064f@mail.gmail.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
From: Nitin Arora <nitin.arora.del@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5541838037302302962=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com

--===============5541838037302302962==
Content-Type: multipart/alternative; boundary=00163646c3465e0b09046d17f1c2

--00163646c3465e0b09046d17f1c2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Michael,

thanks for the reply.
upgrading kernel on our hardware architecture requires quite a lot effort.
So I am looking for some solution specific to XFS.
If some patch can help in this regard then thats the best thing.
Or
I can consider fixing it myself if some help or pointers are provided.

Thanks



On Wed, Jun 24, 2009 at 6:10 PM, Michael Monnerie <
michael.monnerie@is.it-management.at> wrote:

> On Mittwoch 24 Juni 2009 Nitin Arora wrote:
> > I am using linux kernel 2.6.18 with XFS support.
>
> If possible, can you simply try upgrading your ancient kernel to
> something newer? Actual is 2.6.30, with many many bugs fixed, not only
> in XFS.
>
> mfg zmi
> --
> // Michael Monnerie, Ing.BSc    -----      http://it-management.at
> // Tel: 0660 / 415 65 31                      .network.your.ideas.
> // PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
> // Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
> // Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4
>
>

--00163646c3465e0b09046d17f1c2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Michael,<br>
<br>thanks for the reply.<br>
upgrading kernel on our hardware architecture requires quite a lot effort.<=
br>
So I am looking for some solution specific to XFS.<br>
If some patch can help in this regard then thats the best thing.<br>
Or<br>
I can consider fixing it myself if some help or pointers are provided.<br>
<br>
Thanks<br><br><br><br><div class=3D"gmail_quote">On Wed, Jun 24, 2009 at 6:=
10 PM, Michael Monnerie <span dir=3D"ltr">&lt;<a href=3D"mailto:michael.mon=
nerie@is.it-management.at">michael.monnerie@is.it-management.at</a>&gt;</sp=
an> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div class=3D"im"=
>On Mittwoch 24 Juni 2009 Nitin Arora wrote:<br>
&gt; I am using linux kernel 2.6.18 with XFS support.<br>
<br>
</div>If possible, can you simply try upgrading your ancient kernel to<br>
something newer? Actual is 2.6.30, with many many bugs fixed, not only<br>
in XFS.<br>
<br>
mfg zmi<br>
<font color=3D"#888888">--<br>
// Michael Monnerie, Ing.BSc =A0 =A0----- =A0 =A0 =A0<a href=3D"http://it-m=
anagement.at" target=3D"_blank">http://it-management.at</a><br>
// Tel: 0660 / 415 65 31 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.networ=
k.your.ideas.<br>
// PGP Key: =A0 =A0 =A0 =A0 &quot;curl -s <a href=3D"http://zmi.at/zmi.asc"=
 target=3D"_blank">http://zmi.at/zmi.asc</a> | gpg --import&quot;<br>
// Fingerprint: AC19 F9D5 36ED CD8A EF38 =A0500E CE14 91F7 1C12 09B4<br>
// Keyserver: <a href=3D"http://wwwkeys.eu.pgp.net" target=3D"_blank">wwwke=
ys.eu.pgp.net</a> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Key-ID: 1C1209B4<br>
<br>
</font></blockquote></div><br>

--00163646c3465e0b09046d17f1c2--


--===============5541838037302302962==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5541838037302302962==--
