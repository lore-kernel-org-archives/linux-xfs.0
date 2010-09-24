Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OIHPeJ195926 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 13:17:25 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A29C69BE06
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 11:18:18 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id kgMSKclRZZEwAz95 for
	<xfs@oss.sgi.com>; Fri, 24 Sep 2010 11:18:18 -0700 (PDT)
Date: Fri, 24 Sep 2010 20:18:07 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100924201807.16460606@galadriel.home>
In-Reply-To: <AANLkTimXCo0YtjmdPo9RvX=KfQCjJkkL9hQr3h63UJX7@mail.gmail.com>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<AANLkTimXCo0YtjmdPo9RvX=KfQCjJkkL9hQr3h63UJX7@mail.gmail.com>
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
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: Ryszard Stawiarski <ryszard.stawiarski@open-e.com>, ??ukasz Wittig <lukasz.wittig@open-e.com>, Artur Piechocki <artur.piechocki@open-e.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Slawomir Nowakowski <slawomir.nowakowski@open-e.com>

Le Fri, 24 Sep 2010 08:10:51 -0700 vous =E9criviez:

> Sounds like iSCSI-SCST to a vdisk_fileio on a file under xfs on a LUN
> on the Areca RAID controller ...

I use iet and it works fine. It has the beneit of allowing easy copy,
backup, etc of the virtual lun; and it allows thin provisioning too.

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
