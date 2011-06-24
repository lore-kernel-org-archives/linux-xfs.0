Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5O2UcY6238656 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 21:30:38 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 720771759DA4
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 19:30:36 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id lxs9DGaIqau83IJ9
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 19:30:36 -0700 (PDT)
Received: by vws13 with SMTP id 13so1919811vws.26
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 19:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=0Xk6XnU8nrCuKhMyiz-fRggnbrw@mail.gmail.com>
References: <BANLkTi=0Xk6XnU8nrCuKhMyiz-fRggnbrw@mail.gmail.com>
Date: Fri, 24 Jun 2011 08:00:35 +0530
Message-ID: <BANLkTi=9KAEedCfwiBBVxzU3AhQcroTGyw@mail.gmail.com>
Subject: Re: xfstests 228 output log differ
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1201968698909904953=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1201968698909904953==
Content-Type: multipart/alternative; boundary=485b3961890e8b20cc04a66bfc39

--485b3961890e8b20cc04a66bfc39
Content-Type: text/plain; charset=UTF-8

Resolved using bash version 4.2

With Regards,
Ajeet Kumar Yadav
On Jun 23, 2011 12:16 PM, "Ajeet Yadav" <ajeet.yadav.77@gmail.com> wrote:
> Dear all,
> I have attached the log of xfstests 228, the test case seems to PASS
> on my target (MIPS 2.6.35.13) but log differ because of additional
> information.
> Can anyone tell how to fix it
>
> QA output created by 228
> File size limit is now set to 100 MB.
> Let us try to preallocate 101 MB. This should fail.
> -File size limit exceeded
> +./228: line 78: 1674 File size limit exceeded$XFS_IO_PROG -F -f -c
> 'falloc 0 101m' $TEST_DIR/ouch
> Let us now try to preallocate 50 MB. This should succeed.
> Test over.

--485b3961890e8b20cc04a66bfc39
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p>Resolved using bash version 4.2</p>
<p>With Regards,<br>
Ajeet Kumar Yadav</p>
<div class=3D"gmail_quote">On Jun 23, 2011 12:16 PM, &quot;Ajeet Yadav&quot=
; &lt;<a href=3D"mailto:ajeet.yadav.77@gmail.com">ajeet.yadav.77@gmail.com<=
/a>&gt; wrote:<br type=3D"attribution">&gt; Dear all,<br>&gt; I have attach=
ed the log of xfstests 228, the test case seems to PASS<br>
&gt; on my target (MIPS 2.6.35.13) but log differ because of additional<br>=
&gt; information.<br>&gt; Can anyone tell how to fix it<br>&gt; <br>&gt;  Q=
A output created by 228<br>&gt;  File size limit is now set to 100 MB.<br>
&gt;  Let us try to preallocate 101 MB. This should fail.<br>&gt; -File siz=
e limit exceeded<br>&gt; +./228: line 78:  1674 File size limit exceeded$XF=
S_IO_PROG -F -f -c<br>&gt; &#39;falloc 0 101m&#39; $TEST_DIR/ouch<br>&gt;  =
Let us now try to preallocate 50 MB. This should succeed.<br>
&gt;  Test over.<br></div>

--485b3961890e8b20cc04a66bfc39--


--===============1201968698909904953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1201968698909904953==--
