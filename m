Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70E627F58
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 18:33:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E699AC003
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 16:32:57 -0700 (PDT)
Received: from mail-qg0-f49.google.com (mail-qg0-f49.google.com
	[209.85.192.49]) by cuda.sgi.com with ESMTP id 8y8WDzN9MTmRflNK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Jun 2014 16:32:56 -0700 (PDT)
Received: by mail-qg0-f49.google.com with SMTP id f51so2343054qge.36
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 16:32:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140625232222.GS4453@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
	<CA+o=1OXY8Ay8CSgsdiAOTacBa9800FiMKGbr0DdkE_YVpewqBw@mail.gmail.com>
	<20140625220336.GN9508@dastard>
	<CA+o=1OWptqFq87E0ncmYH2T6yEzeGheefE-o_VAm7-E_0Z+NJA@mail.gmail.com>
	<20140625232222.GS4453@dastard>
Date: Thu, 26 Jun 2014 01:32:56 +0200
Message-ID: <CA+o=1OXeRSs7ZXhnTdNrsuu+ozN0k=KmGa068=HqsMQ13XnRYQ@mail.gmail.com>
Subject: Re: Metadata CRC error upon unclean unmount
From: Fanael Linithien <fanael4@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

2014-06-26 1:22 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> The before-mount image shows the CRC error, so it didn't come from
> log recovery. It may have come from recovery in the previous
> iteration, - do you still have the pre-mount images from the prior
> iteration before the crash error was detected?

I don't have anything from between that log CRC eror and these. Should
I try again?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
