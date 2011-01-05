Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p05ATPSd147800 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 04:29:25 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0E7E234231
	for <xfs@oss.sgi.com>; Wed,  5 Jan 2011 02:31:31 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id OXGjDUJdUDvfA08u for
	<xfs@oss.sgi.com>; Wed, 05 Jan 2011 02:31:31 -0800 (PST)
Date: Wed, 5 Jan 2011 11:31:26 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: using raid devices raw, loop devices ?
Message-ID: <20110105113126.553d4b0e@harpe.intellique.com>
In-Reply-To: <CFFC47E79E870F4EBAD0CA24D8CD7652ED34D5BAAF@CRW-EXM01.int.cggveritas.com>
References: <CFFC47E79E870F4EBAD0CA24D8CD7652ED34D5BAAF@CRW-EXM01.int.cggveritas.com>
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
To: Larsen Tore =?ISO-8859-1?Q?H=F8ivaag?= <tore.hoivaag.larsen@cggveritas.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Le Wed, 5 Jan 2011 08:59:59 +0000
Larsen, Tore H=F8ivaag <tore.hoivaag.larsen@cggveritas.com> =E9crivait:

> Comments?   What causes the occasional corruption? Boot time fsck,
> dmraid?  Volume manager daemons?
> =


Probably the volume isn't properly unmounted at shutdown. When does the
problem occur? At every boot?


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
