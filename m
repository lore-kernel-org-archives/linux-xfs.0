Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1D3E7F5E
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2014 10:55:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C14468F804B
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2014 08:55:24 -0700 (PDT)
Received: from mail-qa0-f68.google.com (mail-qa0-f68.google.com
	[209.85.216.68]) by cuda.sgi.com with ESMTP id zppDK11tjsaV99Fg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Aug 2014 08:55:20 -0700 (PDT)
Received: by mail-qa0-f68.google.com with SMTP id dc16so2033777qab.11
	for <xfs@oss.sgi.com>; Sat, 09 Aug 2014 08:55:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+o=1OX+Qq4Scq=su1MDDknRXJGL8F=7WV8P0PCeDjYep7rLnA@mail.gmail.com>
References: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
	<20140809005404.GG26465@dastard>
	<CA+o=1OX+Qq4Scq=su1MDDknRXJGL8F=7WV8P0PCeDjYep7rLnA@mail.gmail.com>
Date: Sat, 9 Aug 2014 17:55:19 +0200
Message-ID: <CA+o=1OXmM+WsFh-ipS4d8hn6RKvOuv3Zga+66PF4DBehuH-5-A@mail.gmail.com>
Subject: Re: Verifier fixes backported to stable kernels?
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
Cc: xfs@oss.sgi.com

2014-08-09 2:54 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> What fixes are you talking about? List of commits, please, noting
> whether the commit already has a "cc: <stable@vger.kernel.org>" in
> it or not.

These are the commits:

400b9d88757c0bfbdfa97014e090ec40a31c1282
67dc288c21064b31a98a53dc64f6b9714b819fd6 (this is the only one with the cc)
5fd364fee81a7888af806e42ed8a91c845894f2d
ad3714b82c631a34724da09a7daa53afcab952fa

> Patch your kernel with the fixes you've identified are necessary,
> then - it can take some time for fixes to propagate through the
> stable process....

This is what I'm trying to avoid, out of sheer laziness. I suppose I'm
going to have to do that if I want to have a working linux, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
