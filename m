Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 23F457F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 22:57:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6455AC001
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 20:57:22 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	Ir1IJxsvqz8svJyu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 20:57:21 -0700 (PDT)
Received: by mail-wi0-f173.google.com with SMTP id ey11so2058876wid.0
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 20:57:20 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Oct 2013 20:57:20 -0700
Message-ID: <CAGa4099etDS8eBGCQ_Se2oQxObO8ZSqHpGeXzeUCpCz3S7XnBw@mail.gmail.com>
Subject: xfs_repair fatal error -- name create failed in lost+found,
	filesystem may be out of space
From: Viet Nguyen <vietnguyen@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4329994301067715824=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4329994301067715824==
Content-Type: multipart/alternative; boundary=f46d043c093285099a04e8e7d013

--f46d043c093285099a04e8e7d013
Content-Type: text/plain; charset=ISO-8859-1

Hi,
Me again. I've got get another corrupted drive and I'm getting a different
error for xfs_repair:

fatal error -- name create failed in lost+found (117), filesystem may be
out of space

When mounted the filesystem is only 53% used.

Any ideas?

Thanks,
Viet

--f46d043c093285099a04e8e7d013
Content-Type: text/html; charset=ISO-8859-1

<div dir="ltr"><div>Hi,</div><div>Me again. I&#39;ve got get another corrupted drive and I&#39;m getting a different error for xfs_repair:</div><div><br></div><div>fatal error -- name create failed in lost+found (117), filesystem may be out of space</div>
<div><br></div><div>When mounted the filesystem is only 53% used.</div><div><br></div><div>Any ideas?</div><div><br></div><div>Thanks,</div><div>Viet</div></div>

--f46d043c093285099a04e8e7d013--


--===============4329994301067715824==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4329994301067715824==--
