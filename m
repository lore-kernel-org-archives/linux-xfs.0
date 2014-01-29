Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 76BF87F86
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 11:42:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60E9030407A
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 09:42:55 -0800 (PST)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id vPETxuk1Dz2SrIs2 for
	<xfs@oss.sgi.com>; Wed, 29 Jan 2014 09:42:50 -0800 (PST)
Date: Wed, 29 Jan 2014 18:42:50 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
Message-ID: <20140129184250.7af7200f@harpe.intellique.com>
In-Reply-To: <1391014448.2573.95.camel@islero.dmt.upm.es>
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
	<1391009068.4294.83.camel@montana.filmlight.ltd.uk>
	<1391014448.2573.95.camel@islero.dmt.upm.es>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: sillero@torroja.dmt.upm.es
Cc: xfs@oss.sgi.com, Roger Willcocks <roger@filmlight.ltd.uk>, guillem <guillem@torroja.dmt.upm.es>

Le Wed, 29 Jan 2014 17:54:08 +0100
"Juan A. Sillero" <sillero@torroja.dmt.upm.es> =E9crivait:

> We'd like to know your opinion about what to do next. The data is
> still probably on the disks, but the RAID topology is gone.  We'd
> also like to know if someone has experienced a similar hardware
> problem that could give us some advice.

I tought it was a dmraid raid 5 device? If it's a RAID controller, what
brand/model is it? =


At this point you could give a try to UFS Explorer.

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
