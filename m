Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6R4xh5o163662 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 23:59:43 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38FE91BE7FB5
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 22:02:47 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id cKOyk3zhpMz9SgaB for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 22:02:47 -0700 (PDT)
Subject: Re: filesystem shrinks after using xfs_repair
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20100726230653.5da272c1@galadriel.home>
Date: Mon, 26 Jul 2010 22:02:40 -0700
Message-Id: <89B1ECDD-E9F4-4044-953A-76987AAF8EFE@ucsc.edu>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
	<20100726114940.7a97f29e@harpe.intellique.com>
	<AE59CF1C-6E28-4468-892A-394AE324EEF0@ucsc.edu>
	<20100726230653.5da272c1@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Hi,

Thanks. I tried a Knoppix live DVD (latest version) today and it does seem =
to have xfs-progs, but I can't get it to recognize the lvm volume that the =
filesystem is on. LVM2 programs are available, but 'vgscan  --mknodes' turn=
s up nothing. I'll continue to look into it, but if anyone has any ideas, p=
lease let me know.

thanks,

Eli


On Jul 26, 2010, at 2:06 PM, Emmanuel Florac wrote:

> Le Mon, 26 Jul 2010 10:22:11 -0700 vous =E9criviez:
> =

>> I think the Live CD is a great suggestion. I was just thinking
>> though. do you know of a Live CD that has XFS utilities on it? From
>> what I've seen, I've had to install XFS utilities after installing
>> the OS, which I don't think one can do with a live CD. I can look,
>> but if you know of one, that would probably save some digging.
> =

> I'm pretty sure Ubuntu and Knoppix both come with xfs-progs. =

> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
