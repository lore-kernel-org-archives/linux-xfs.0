Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Oct 2006 13:34:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9BKYYaG018660
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 13:34:36 -0700
Received: from mailer.gwdg.de (mailer.gwdg.de [134.76.10.26])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD0B84913BC
	for <xfs@oss.sgi.com>; Wed, 11 Oct 2006 12:32:17 -0700 (PDT)
Date: Wed, 11 Oct 2006 21:30:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: GRIO in Linux XFS?
In-Reply-To: <CAEAF2308EEED149B26C2C164DFB20F4DDE78B@ALPMLVEM06.e2k.ad.ge.com>
Message-ID: <Pine.LNX.4.61.0610112129060.9822@yvahk01.tjqt.qr>
References: <CAEAF2308EEED149B26C2C164DFB20F4DDE78B@ALPMLVEM06.e2k.ad.ge.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Phetteplace, Thad (GE Healthcare, consultant)" <Thad.Phetteplace@ge.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

>
>what is the status of GRIO support in the Linux port of XFS?

Called realtime volume.
(http://en.wikipedia.org/wiki/XFS section 2.11)

>Also, if the answer is 'non existent', what is the recommended
>alternative?  I've got an application that needs to stream a
>huge amount of data to the harddrive without dropping any and
>without blocking the sender.  We will be pushing the limits
>of our high-end raid striped disks.  This seems the exactly
>the type of thing GRIO was made for, but last I heard it was
>missing from Linux XFS with no plans to add it.  Any change
>in that?  I know I can get almost there with I/O priorities
>and the RT features in 2.6... but its not quite the same
>thing.
> 
>Apologies if this has been beat to death here or elsewhere...
>I've googled the heck out of this and rummaged around in the
>list archives (as much as this fscking corporate firewall will
>let me) with little result.  I'll gladly RTFM if someone can
>point me at the right one.  :-/
>
>Feel free to CC me on replies, as I read the LKML in digest
>format.
>
>Thanks,
>
>Thad Phetteplace
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

	-`J'
-- 
