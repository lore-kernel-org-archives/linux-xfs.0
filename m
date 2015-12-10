Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F09F7F51
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 12:08:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 203B4AC004
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 10:08:42 -0800 (PST)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com
	[209.85.192.41]) by cuda.sgi.com with ESMTP id KVwCl1i7hkoW9UDS
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2015 10:08:40 -0800 (PST)
Received: by qgeb1 with SMTP id b1so155238531qge.1
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 10:08:39 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 10 Dec 2015 10:08:39 -0800
Message-ID: <CACQ+YcstiCVsVj-pLn0WP8Qkr8XRA9A8d9cwH5wb0Zm4=doPvA@mail.gmail.com>
Subject: using system tap or dtrace to diagnose xfs problems
From: Ed Peschko <horos22@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8290675769947903416=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8290675769947903416==
Content-Type: multipart/alternative; boundary=001a1134f63aa8ec1605268f18af

--001a1134f63aa8ec1605268f18af
Content-Type: text/plain; charset=UTF-8

All,

I was wondering; has anyone used system tap or dtrace to diagnose xfs
issues on linux systems (esp centos)?

I was thinking about our experience with busy resources, and that seemed an
ideal way to get round the problem, or at least get a handle on it.

But it'd be great if I could get some first hand tips on using these tools
here. I'm more familiar with dtrace - and it is supposed to be AFAICT more
stable - but I'm not sure how great the port is on linux.

Thanks much for any info..

--001a1134f63aa8ec1605268f18af
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">All,=C2=A0<div><br></div><div>I was wondering; has anyone =
used system tap or dtrace to diagnose xfs issues on linux systems (esp cent=
os)?</div><div><br></div><div>I was thinking about our experience with busy=
 resources, and that seemed an ideal way to get round the problem, or at le=
ast get a handle on it.=C2=A0</div><div><br></div><div>But it&#39;d be grea=
t if I could get some first hand tips on using these tools here. I&#39;m mo=
re familiar with dtrace - and it is supposed to be AFAICT more stable - but=
 I&#39;m not sure how great the port is on linux.</div><div><br></div><div>=
Thanks much for any info..</div></div>

--001a1134f63aa8ec1605268f18af--


--===============8290675769947903416==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8290675769947903416==--
