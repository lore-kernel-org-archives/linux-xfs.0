Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D338A7CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 02:39:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 928038F8040
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:39:40 -0700 (PDT)
Received: from mail-lb0-f193.google.com (mail-lb0-f193.google.com
	[209.85.217.193]) by cuda.sgi.com with ESMTP id
	hY6Vfa8drnV470M9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:39:38 -0700 (PDT)
Received: by mail-lb0-f193.google.com with SMTP id wn5so10293440lbb.2
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:39:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160321073016.GR30721@dastard>
References: <CANq6e6jjBqis7dhTTPST+bKDbwvYDbzvPg3G7V3eiD-+OB2U7A@mail.gmail.com>
	<20160321063848.GK11812@dastard>
	<CANq6e6gHuZsb-g_WAHH5sypedtUb0i6UADp5B=Rio7Cw=G9z1w@mail.gmail.com>
	<20160321073016.GR30721@dastard>
Date: Mon, 21 Mar 2016 08:39:37 +0100
Message-ID: <CANq6e6jPz5fDeCCQuZFEYmApCFH0-pkBYJ-Z-s7zYap3QM3sEQ@mail.gmail.com>
Subject: Re: obtaining xfstests repository
From: Sonia mandelbrott <sonia.mandelbrott@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3135393701524499230=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3135393701524499230==
Content-Type: multipart/alternative; boundary=001a1133bad0dcc7e2052e8a32fc

--001a1133bad0dcc7e2052e8a32fc
Content-Type: text/plain; charset=UTF-8

It is probably because I am using my work connection...
But thank you for all the replies :)


On Mon, Mar 21, 2016 at 8:30 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Mar 21, 2016 at 08:22:09AM +0100, Sonia mandelbrott wrote:
> > Thank you for your replies, here is output when used your link:
> >
> > -bash-4.2$ git clone git://
> git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> > Cloning into 'xfstests-dev'...
> > fatal: unable to connect to git.kernel.org:
> > git.kernel.org[0: 149.20.4.72]: errno=Connection timed out
> > git.kernel.org[1: 199.204.44.194]: errno=Connection timed out
> > git.kernel.org[2: 198.145.20.140]: errno=Connection timed out
> > git.kernel.org[3: 2620:3:c000:a:0:1991:8:25]: errno=Network is
> unreachable
> > git.kernel.org[4: 2001:4f8:1:10:0:1991:8:25]: errno=Network is
> unreachable
>
> There's almost certainly a firewall in your way. Try cloning over
> http.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a1133bad0dcc7e2052e8a32fc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">It is probably because I am using my work connection...<di=
v>But thank you for all the replies :)<br><div><br></div></div></div><div c=
lass=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Mar 21, 2016 at=
 8:30 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromor=
bit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> wrote:<br><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #=
ccc solid;padding-left:1ex"><span class=3D"">On Mon, Mar 21, 2016 at 08:22:=
09AM +0100, Sonia mandelbrott wrote:<br>
</span><span class=3D"">&gt; Thank you for your replies, here is output whe=
n used your link:<br>
&gt;<br>
&gt; -bash-4.2$ git clone git://<a href=3D"http://git.kernel.org/pub/scm/fs=
/xfs/xfstests-dev.git" rel=3D"noreferrer" target=3D"_blank">git.kernel.org/=
pub/scm/fs/xfs/xfstests-dev.git</a><br>
&gt; Cloning into &#39;xfstests-dev&#39;...<br>
&gt; fatal: unable to connect to <a href=3D"http://git.kernel.org" rel=3D"n=
oreferrer" target=3D"_blank">git.kernel.org</a>:<br>
&gt; <a href=3D"http://git.kernel.org" rel=3D"noreferrer" target=3D"_blank"=
>git.kernel.org</a>[0: 149.20.4.72]: errno=3DConnection timed out<br>
&gt; <a href=3D"http://git.kernel.org" rel=3D"noreferrer" target=3D"_blank"=
>git.kernel.org</a>[1: 199.204.44.194]: errno=3DConnection timed out<br>
&gt; <a href=3D"http://git.kernel.org" rel=3D"noreferrer" target=3D"_blank"=
>git.kernel.org</a>[2: 198.145.20.140]: errno=3DConnection timed out<br>
&gt; <a href=3D"http://git.kernel.org" rel=3D"noreferrer" target=3D"_blank"=
>git.kernel.org</a>[3: 2620:3:c000:a:0:1991:8:25]: errno=3DNetwork is unrea=
chable<br>
&gt; <a href=3D"http://git.kernel.org" rel=3D"noreferrer" target=3D"_blank"=
>git.kernel.org</a>[4: 2001:4f8:1:10:0:1991:8:25]: errno=3DNetwork is unrea=
chable<br>
<br>
</span>There&#39;s almost certainly a firewall in your way. Try cloning ove=
r<br>
http.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--001a1133bad0dcc7e2052e8a32fc--


--===============3135393701524499230==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3135393701524499230==--
