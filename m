Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 920087F3F
	for <xfs@oss.sgi.com>; Sat, 20 Dec 2014 16:53:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F573AC002
	for <xfs@oss.sgi.com>; Sat, 20 Dec 2014 14:53:00 -0800 (PST)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
	[209.85.215.45]) by cuda.sgi.com with ESMTP id vfuB8dqU9mIYGFQa
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 20 Dec 2014 14:52:59 -0800 (PST)
Received: by mail-la0-f45.google.com with SMTP id gq15so2483853lab.32
	for <xfs@oss.sgi.com>; Sat, 20 Dec 2014 14:52:58 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 20 Dec 2014 23:52:57 +0100
Message-ID: <CAHJqNbx8qrs6OosFq1TGz4jqzxh82zvLRzxQ1oWpOp5MP6h3oQ@mail.gmail.com>
Subject: finobt option for end user
From: Alphazo <alphazo@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2914340324470642357=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2914340324470642357==
Content-Type: multipart/alternative; boundary=001a11c3da2ec269bf050aadaf6f

--001a11c3da2ec269bf050aadaf6f
Content-Type: text/plain; charset=UTF-8

Hello,

I'm pretty new to XFS. I'm considering moving away from ext4 to XFS because
of the new self-describing option, performance and reliability improvements
that XFS went through over the past year. Now I'm puzzled with the new free
inode btree option (finobt). I tried to find some documentation about it
but couldn't find the pros or cons. So from an end-user perspective with a
couple of TB worth of photos:
- Does it improve overall reliability?
- Does it provide faster fsck/repair?
- Does it improve any read or write operation?
- Is it safe to use and does it recover as well as with finobt=0?
- What is the typical case for enabling it and would you recommend using it
for any new fs creation?

Thank you in advance for your pointers.
Alphazo

--001a11c3da2ec269bf050aadaf6f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><br></div><div>I&#39;m pretty new to XFS. I&#39=
;m considering moving away from ext4 to XFS because of the new self-describ=
ing option, performance and reliability improvements that XFS went through =
over the past year. Now I&#39;m puzzled with the new free inode btree optio=
n (finobt). I tried to find some documentation about it but couldn&#39;t fi=
nd the pros or cons. So from an end-user perspective with a couple of TB wo=
rth of photos:</div><div>- Does it improve overall reliability?</div><div>-=
 Does it provide faster fsck/repair?</div><div>- Does it improve any read o=
r write operation?</div><div>- Is it safe to use and does it recover as wel=
l as with finobt=3D0?</div><div>- What is the typical case for enabling it =
and would you recommend using it for any new fs creation?</div><div><br></d=
iv><div>Thank you in advance for your pointers.</div><div>Alphazo</div></di=
v>

--001a11c3da2ec269bf050aadaf6f--


--===============2914340324470642357==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2914340324470642357==--
