Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57A7A7F50
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 04:15:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4726E30405F
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 02:15:06 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	uDUOZQySYFUD1haN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 02:15:04 -0700 (PDT)
Received: by iodt126 with SMTP id t126so182441435iod.2
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 02:15:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150817215549.GD714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<20150817215549.GD714@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 18 Aug 2015 11:14:44 +0200
Message-ID: <CACj3i73LZZYgdQXt5enPPxK3urif=vN3qj-Fwe6TL6QDk1H5vg@mail.gmail.com>
Subject: Re: [PATCH 00/11] xfsprogs: Partial OS X support
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6290871219708172649=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============6290871219708172649==
Content-Type: multipart/alternative; boundary=001a1140f3a67e8aee051d925a42

--001a1140f3a67e8aee051d925a42
Content-Type: text/plain; charset=UTF-8

On Mon, Aug 17, 2015 at 11:55 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Aug 17, 2015 at 06:23:15PM +0200, Jan Tulak wrote:
> > This is a third iteration of OS X support patches. Notes with
> information about
> > changes in every patch since the last bulk submittation (or at least the
> last
> > iteration of that patch) follows.
>
> What version of the patches are these? I see some patches in
> previous thread with "v4" on them, so I don't know whether they are
> more recent than these or not.
>
> FWIW, I'm not picking on you; I'm trying to explain what I see and
> why it makes it difficult for me to work out what is going on so you
> understand why I might be asking for specific information. Nobody
> explains this stuff to new developers; you pick it up through trial
> an error, and emails like this :/
>

Thank you much for this email - without someone providing me a feedback,
I would have just a little hope of getting better. :-)
Next patches should be versioned and changelogged better.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--001a1140f3a67e8aee051d925a42
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Mon, Aug 17, 2015 at 11:55 PM, Dave Chinner <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On=
 Mon, Aug 17, 2015 at 06:23:15PM +0200, Jan Tulak wrote:<br>
&gt; This is a third iteration of OS X support patches. Notes with informat=
ion about<br>
&gt; changes in every patch since the last bulk submittation (or at least t=
he last<br>
&gt; iteration of that patch) follows.<br>
<br>
</span>What version of the patches are these? I see some patches in<br>
previous thread with &quot;v4&quot; on them, so I don&#39;t know whether th=
ey are<br>
more recent than these or not.<br>
<br>
FWIW, I&#39;m not picking on you; I&#39;m trying to explain what I see and<=
br>
why it makes it difficult for me to work out what is going on so you<br>
understand why I might be asking for specific information. Nobody<br>
explains this stuff to new developers; you pick it up through trial<br>
an error, and emails like this :/<br></blockquote><div><br></div><div>Thank=
 you much for this email - without someone providing me a feedback,</div><d=
iv>I would have just a little hope of getting better. :-)</div><div>Next pa=
tches should be versioned and changelogged better.<br></div><div><br></div>=
<div>Cheers,</div><div>Jan</div><div><br></div></div>-- <br><div class=3D"g=
mail_signature"><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:=
jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--001a1140f3a67e8aee051d925a42--


--===============6290871219708172649==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6290871219708172649==--
