Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7FvW1w175576 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 09:57:33 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CA5A1CEC33
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 07:59:18 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id wLH9ftkdwLZUsaVo for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 07:59:18 -0800 (PST)
Date: Tue, 7 Dec 2010 16:59:17 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: kernel panic-xfs errors
Message-ID: <20101207165917.0c96dd95@harpe.intellique.com>
In-Reply-To: <30397503.post@talk.nabble.com>
References: <30397503.post@talk.nabble.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: blacknred <leo1783@hotmail.co.uk>
Cc: xfs@oss.sgi.com

Le Tue, 7 Dec 2010 07:42:56 -0800 (PST)
blacknred <leo1783@hotmail.co.uk> =E9crivait:

> But the server has hung again after an hour. No panic this time,
> checked dmesg output and it again
> shows same =

> XFS: bad magic number
> XFS: SB validate failed =

> messages.. Any thoughts??
> =


What is the kernel version, distro, and xfs_progs? You didn't update
anything but the controller firmware? Is the new firmware compatible
with the previous driver?

This one is intriguing :

 [<f894585c>] do_cciss_request+0x397/0x3a3 [cciss]

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
