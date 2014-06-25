Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D85C37F3F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 11:09:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFA588F8068
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 09:09:09 -0700 (PDT)
Received: from mail-qa0-f68.google.com (mail-qa0-f68.google.com
	[209.85.216.68]) by cuda.sgi.com with ESMTP id b5dT3QAYPW2AB8zA
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Jun 2014 09:09:07 -0700 (PDT)
Received: by mail-qa0-f68.google.com with SMTP id v10so521074qac.3
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 09:09:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140625012144.GK9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
Date: Wed, 25 Jun 2014 18:09:07 +0200
Message-ID: <CA+o=1OXY8Ay8CSgsdiAOTacBa9800FiMKGbr0DdkE_YVpewqBw@mail.gmail.com>
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

First try, and something is wrong already.

Dmesg: https://clbin.com/e8HwM
Pre-mount metadata: https://clbin.com/0thyz
Post-mount metadata: https://clbin.com/WTIuF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
