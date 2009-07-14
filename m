Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6E6GY3Q094207 for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 01:16:34 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 408FB10A2228
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 23:24:38 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id TM3yI116XHOCg9KM for
	<xfs@oss.sgi.com>; Mon, 13 Jul 2009 23:24:38 -0700 (PDT)
References: <200907031320.48358@zmi.at> <4A5C0606.4030102@sandeen.net>
	<200907140805.40854@zmi.at>
Message-Id: <87A18C52-F601-491F-94EA-ED16AB6CE574@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <200907140805.40854@zmi.at>
Mime-Version: 1.0 (iPod Mail 7A341)
Subject: Re: [PATCH] xfs_repair - do not attempt to set shortform attr header
	when clearing
Date: Tue, 14 Jul 2009 01:16:17 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Jul 14, 2009, at 1:05 AM, Michael Monnerie <michael.monnerie@is.it-management.at 
 > wrote:

> On Dienstag 14 Juli 2009 Eric Sandeen wrote:
>> Whew.
>
> It's people like you I'm afraid of ;-) Is there still blood in your
> vains or was it replaced with silicone once?

Heh.. :)

>
> To ask in a simple way: Will this version fix the problem on my  
> disk? If
> yes, where could I download it? (git ..?)
>
It's not committed yet, you could patch it yourself now, or wait til  
it's reviewed and committed...

-Eric
> mfg zmi
> -- 
> // Michael Monnerie, Ing.BSc    -----      http://it-management.at
> // Tel: 0660 / 415 65 31                      .network.your.ideas.
> // PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
> // Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
> // Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
