Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CBF857F54
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:56:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CCDA30404E
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:56:04 -0700 (PDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	D4wBIxjTMBpaDClw (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:55:57 -0700 (PDT)
Received: by mail-wi0-f181.google.com with SMTP id n15so6221124wiw.2
	for <xfs@oss.sgi.com>; Tue, 03 Jun 2014 02:55:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <538D9412.3040009@gmail.com>
References: <5363B4C9.4000900@sandeen.net> <5363CB5E.3090008@gmail.com>
	<5363CD70.3000006@sandeen.net> <5363DBD7.4060002@gmail.com>
	<5363E65C.6010006@sandeen.net> <5363ECE8.6030706@gmail.com>
	<20140502233512.GE26353@dastard> <536432A0.6000405@gmail.com>
	<20140503030221.GJ26353@dastard> <538C5E67.6090005@gmail.com>
	<20140602234135.GO6677@dastard> <538D9412.3040009@gmail.com>
Date: Tue, 3 Jun 2014 11:55:55 +0200
Message-ID: <CAAxjCEzz5n85zAH5HuUQkfxKvzZt5_+cPCj3uzZR7U69H+2tDw@mail.gmail.com>
Subject: Re: XFS filesystem claims to be mounted after a disconnect
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Martin Papik <mp6058@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

>From skimming this thread, it seems that there is some hardware issue
at work here, but nonetheless, I had a very similar situation a while
ago that was rather puzzling to me at the time, having to do with
mount namespaces:
http://oss.sgi.com/pipermail/xfs/2012-August/020910.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
