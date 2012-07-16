Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GMGACj020672 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 17:16:10 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	a9rqBZLaT0mfbKP1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jul 2012 15:16:09 -0700 (PDT)
Received: by obbup19 with SMTP id up19so10879176obb.26
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 15:16:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5004875D.1020305@hardwarefreak.com>
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<CAAxjCEzEiXv5Kna9zxZ-ePbhNg6nfRinkU=PCuyX3QHesq5qcg@mail.gmail.com>
	<5004875D.1020305@hardwarefreak.com>
Date: Tue, 17 Jul 2012 00:16:08 +0200
Message-ID: <CAAxjCEzHcYqTOjPpDmZvAPg0LWiGmdpuyghnb03fae2oKFbV4Q@mail.gmail.com>
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
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

>> If I thought that the internal RAID was bad, that's only because I
>> have not yet experienced an external enclosure from HP attached via
>> FibreChannel (P2000 G3 MSA, QLogic Corp. ISP2532-based 8Gb Fibre
>> Channel to PCI Express HBA). Unfortunately, I don't have detailed
>> information about the configuration of this enclosure, except that
>> it's a RAID6 volume, with 10 or 12 disks, I believe.
>
> Without that information the numbers below may tend to be a bit meaningless.

Yes, probably, but I likely won't get at the information, let alone
change or tweak anything. But even with the most naive setup, a good
storage stack "should" not exhibit this kind of behavior.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
