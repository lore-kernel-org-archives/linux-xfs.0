Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JDA83v188733 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 08:10:08 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8904C16C26DF
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 06:18:07 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id C4FHdOgARp6qpeM8
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 06:18:07 -0700 (PDT)
Message-ID: <4E9ECC2C.5050700@profihost.ag>
Date: Wed, 19 Oct 2011 15:10:04 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
	<20111010014509.GT3159@dastard>
	<20111010055546.GA1641@x4.trippels.de>
	<4E9EB187.40306@profihost.ag>
	<20111019113404.GA13670@infradead.org>
In-Reply-To: <20111019113404.GA13670@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>, xfs@oss.sgi.com

Am 19.10.2011 13:34, schrieb Christoph Hellwig:
> On Wed, Oct 19, 2011 at 01:16:23PM +0200, Stefan Priebe - Profihost AG wrote:
>> Any news on this problem? What happens with the next long term
>> stable kernel 3.0.X? How do you proceed with this bug?
>
> The patches are in 3.1-rc10 and I have submitted them for 3.0-stable,
> but haven't heard anything back from Greg yet.
>
Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
