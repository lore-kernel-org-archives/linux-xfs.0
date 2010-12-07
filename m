Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7E8uqQ158213 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 08:08:56 -0600
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E2131C9EA96
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 06:10:41 -0800 (PST)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id QsUtZ6AdEOBh3REs for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 06:10:41 -0800 (PST)
Date: Tue, 7 Dec 2010 15:10:39 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: possible xfs corruption
Message-ID: <20101207151039.25d45cb5@harpe.intellique.com>
In-Reply-To: <30395558.post@talk.nabble.com>
References: <30395558.post@talk.nabble.com>
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

Le Tue, 7 Dec 2010 03:49:49 -0800 (PST)
blacknred <leo1783@hotmail.co.uk> =E9crivait:

> I'm stuck with a storage issue on reboot. Initially doubted the
> storage, but dmesg throws these errors. Now wondering whether this is
> a fs issue? Any thoughts as to whats going on here?
> =


It looks like a part of the filesystem is physically missing. What is
the underlying device? Apparently it's a SmartArray in some HP server,
did you had a power failure? =


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
