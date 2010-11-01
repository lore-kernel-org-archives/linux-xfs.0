Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1AAVZZ199595 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 05:10:31 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4D96141F54
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 03:11:51 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id TBRweCp9W7piHVes for
	<xfs@oss.sgi.com>; Mon, 01 Nov 2010 03:11:51 -0700 (PDT)
Date: Mon, 1 Nov 2010 11:11:42 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Message-ID: <20101101111142.5db7fa4e@galadriel.home>
In-Reply-To: <4CCE73C8.8070705@profihost.ag>
References: <4CC67450.9020602@profihost.ag>
	<20101026092205.086c0d89@galadriel.home>
	<4CC68249.7050409@profihost.ag> <4CCE73C8.8070705@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: xfs@oss.sgi.com

Le Mon, 01 Nov 2010 09:01:12 +0100 vous =E9criviez:

> but today i got again hundrets of these messages:
> [318343.901809] Filesystem "sdc3": XFS internal error
> xfs_da_do_buf(2) =


That's weird. What do "uname -a" and "free" tells? I'm wondering if
there isn't some low memory condition at work here.

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
