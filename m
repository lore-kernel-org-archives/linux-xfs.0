Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n624og8m063613 for <xfs@oss.sgi.com>; Wed, 1 Jul 2009 23:50:42 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 137D88F80AD
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2009 21:51:12 -0700 (PDT)
Message-Id: <6E6C2EFA-9893-4585-AA36-CDE866C7CE45@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A48D218.5050208@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] add more statics & drop some unused functions
Date: Wed, 1 Jul 2009 23:51:10 -0500
References: <4A1C3D65.4020306@sandeen.net>
	<20090527102319.GA28274@infradead.org>
	<4A48D218.5050208@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs mailing list <xfs@oss.sgi.com>


On Jun 29, 2009, at 9:39 AM, Eric Sandeen wrote:

> Christoph Hellwig wrote:
>> On Tue, May 26, 2009 at 02:05:09PM -0500, Eric Sandeen wrote:
>>> A lot more functions could be made static, but they need
>>> forward declarations; this does some easy ones, and also
>>> found a few unused functions in the process.
>>
>> Looks good to me.
>>
>
> Felix, do you plan to merge this one?

Eric, this patch doesn't apply cleanly now:

Applying xfs: add more statics & drop some unused functions
error: patch failed: fs/xfs/linux-2.6/xfs_sync.c:640
error: fs/xfs/linux-2.6/xfs_sync.c: patch does not apply
error: patch failed: fs/xfs/linux-2.6/xfs_sync.h:51
error: fs/xfs/linux-2.6/xfs_sync.h: patch does not apply
Patch failed at 0002.

Can you rebase and repost it?

Thanks,
Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
