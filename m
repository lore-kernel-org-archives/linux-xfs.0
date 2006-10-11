Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 14:19:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9BLJ7aG022501
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 14:19:07 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C328848FA3C
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 14:18:24 -0700 (PDT)
Message-ID: <452D5F49.70808@sandeen.net>
Date: Wed, 11 Oct 2006 16:16:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: GRIO in Linux XFS?
References: <CAEAF2308EEED149B26C2C164DFB20F4DDE78B@ALPMLVEM06.e2k.ad.ge.com> <Pine.LNX.4.61.0610112129060.9822@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0610112129060.9822@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Phetteplace, Thad (GE Healthcare, consultant)" <Thad.Phetteplace@ge.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Jan Engelhardt wrote:
>> what is the status of GRIO support in the Linux port of XFS?
> 
> Called realtime volume.
> (http://en.wikipedia.org/wiki/XFS section 2.11)

Well, not really.  realtime was a part of the old griov1 setup on Irix,
but realtime != GRIO.

-Eric
