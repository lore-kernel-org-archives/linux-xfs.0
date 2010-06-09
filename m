Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o597ea0W002152 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 02:40:37 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1AF810D12B5
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 00:46:08 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WkiTlOcP29OT2S7Q
	for <xfs@oss.sgi.com>; Wed, 09 Jun 2010 00:46:08 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id E40166C3CE
	for <xfs@oss.sgi.com>; Wed,  9 Jun 2010 02:43:07 -0500 (CDT)
Message-ID: <4C0F470D.40805@hardwarefreak.com>
Date: Wed, 09 Jun 2010 02:47:25 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs, 2.6.27=>.32 sync write 10 times slowdown [was: xfs, aacraid
	2.6.27 => 2.6.32 results in 6 times slowdown]
References: <4C0E13A7.20402@msgid.tls.msk.ru>
	<20100608122919.GC7869@dastard>	<4C0EA938.9000104@msgid.tls.msk.ru>
	<20100608231845.GG7869@dastard> <4C0F3819.4000409@msgid.tls.msk.ru>
In-Reply-To: <4C0F3819.4000409@msgid.tls.msk.ru>
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

Michael Tokarev put forth on 6/9/2010 1:43 AM:

>  Adaptec aacraid driver 1.1-5[2456]-ms

Are you able to try newer 2.6.32.x or 2.6.33.x kernels?  Have you tried a
2.6.30 series kernel?  Are you rolling your own kernels or using distro
provided kernels?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
