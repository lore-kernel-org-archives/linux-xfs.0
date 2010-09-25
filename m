Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PEDHUN236778 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:13:17 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55FAC9DBB2
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 07:14:11 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id aM51TwuLi0wgiuZ4 for
	<xfs@oss.sgi.com>; Sat, 25 Sep 2010 07:14:11 -0700 (PDT)
Date: Sat, 25 Sep 2010 16:13:57 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Problem with file system on iSCSI FileIO
Message-ID: <20100925161357.0a30e20a@galadriel.home>
In-Reply-To: <4C9D0E3B.20007@open-e.com>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<AANLkTimXCo0YtjmdPo9RvX=KfQCjJkkL9hQr3h63UJX7@mail.gmail.com>
	<20100924201807.16460606@galadriel.home>
	<4C9D0E3B.20007@open-e.com>
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
To: ryszard.stawiarski@open-e.com
Cc: Richard Sharpe <realrichardsharpe@gmail.com>, =?UTF-8?Q?=C5=81ukasz?= Wittig <lukasz.wittig@open-e.com>, Artur Piechocki <artur.piechocki@open-e.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Nowakowski <slawomir.nowakowski@open-e.com>, Slawomir@oss.sgi.com

Le Fri, 24 Sep 2010 22:46:51 +0200 vous =E9criviez:

> I C that there is no problem with IETD ;-)
> But we need to stay focused on SCST in this case :-)
> =


Yes but you'd need to get sure that it's not scst that breaks the
filesystem. My guess : it actually is. I personnally didn't find SCST
of acceptable production quality.

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
