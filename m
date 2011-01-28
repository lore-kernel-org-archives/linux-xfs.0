Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SEJuDU160317 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 08:19:57 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 255F28E3B25
	for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 06:22:21 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.183]) by cuda.sgi.com with ESMTP id
	WOnDQYSZDceQ6Diq for <xfs@oss.sgi.com>;
	Fri, 28 Jan 2011 06:22:21 -0800 (PST)
Message-ID: <4D42D11A.5040201@teksavvy.com>
Date: Fri, 28 Jan 2011 09:22:18 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard>
	<4D421A68.9000607@teksavvy.com>
	<AANLkTinO1JsX_3NDHS=ew5u2C7VcCHT1Y1Yabnz=RQLO@mail.gmail.com>
In-Reply-To: <AANLkTinO1JsX_3NDHS=ew5u2C7VcCHT1Y1Yabnz=RQLO@mail.gmail.com>
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
To: David Rees <drees76@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>

On 11-01-27 11:14 PM, David Rees wrote:
>
> As suggested before - why are you messing with AGs instead of allocsize?

Who said "instead of"?  I'm using both.

Cheers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
