Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ICbRZV189673 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 07:37:27 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	GF5y8068sOhg2rYE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2012 05:37:25 -0700 (PDT)
Received: by obbup19 with SMTP id up19so2278381obb.26
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 05:37:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAxjCEy2Yj=XWctNg2gACbFy81aTu70YJ13Ee8G6-E3Tqvvs7g@mail.gmail.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
	<CAAxjCEw-NJzZmX3Q5CJ+aZ_Q7Yo39pMU=-hiXk0ghTMq7q3PWA@mail.gmail.com>
	<5004C243.6040404@hardwarefreak.com>
	<20120717052621.GB23387@dastard>
	<50061CEA.4070609@hardwarefreak.com>
	<CAAxjCEwgDKLF=RY0aCCNTMsc1oefXWfyHKh+morYB9zVUrnH-A@mail.gmail.com>
	<50066115.7070807@hardwarefreak.com>
	<CAAxjCExFUJOKaD-LMPfZvCrS34V1VHgtrhgvPP0jZ3Hm1YV=6g@mail.gmail.com>
	<50068EC5.5020704@hardwarefreak.com>
	<CAAxjCEy2Yj=XWctNg2gACbFy81aTu70YJ13Ee8G6-E3Tqvvs7g@mail.gmail.com>
Date: Wed, 18 Jul 2012 14:37:25 +0200
Message-ID: <CAAxjCEzF3nTFoedyKf1o5Nv4yPUJkgvC8nCJcx_2dDx8xqWtWA@mail.gmail.com>
Subject: Re: A little RAID experiment
From: Stefan Ring <stefanrin@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

> At least I have some multi-threaded results from the other two machines:
>
> LSI:
>
> 4 threads
>
> [   2s] reads: 0.00 MB/s writes: 63.08 MB/s fsyncs: 0.00/s response
> time: 0.452ms (95%)
> [   4s] reads: 0.00 MB/s writes: 34.26 MB/s fsyncs: 0.00/s response
> time: 1.660ms (95%)

And because of the bad formatting:
https://github.com/Ringdingcoder/sysbench/blob/master/mail2.txt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
