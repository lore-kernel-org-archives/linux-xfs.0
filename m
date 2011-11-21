Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALE25i1002217
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 08:02:06 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E001B57042D
	for <linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 06:02:03 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 5m56URQKJuIoLVbR for
	<linux-xfs@oss.sgi.com>; Mon, 21 Nov 2011 06:02:03 -0800 (PST)
Date: Mon, 21 Nov 2011 15:01:58 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: stale NFS file handle problem on XFS inode64
Message-ID: <20111121150158.5f8b2512@harpe.intellique.com>
In-Reply-To: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
References: <CAJNJY8Q--O2Z3K6KFxVKOivwaABk+oRtC1y0eQ0nS1WdPNMwsQ@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

Le Mon, 21 Nov 2011 21:00:57 +0800
hank peng <pengxihan@gmail.com> =E9crivait:

> NFS server: kernel version is 2.6.35.6
> NFS client: kernel version is 2.6.18
> =

> Any ideas on how to deal with this problem?

Are the client and the server running a 64 bits kernel?

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
