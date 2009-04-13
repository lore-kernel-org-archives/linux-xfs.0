Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3D9Zk8d097257 for <xfs@oss.sgi.com>; Mon, 13 Apr 2009 04:36:01 -0500
Message-ID: <49E30746.3010509@garzik.org>
Date: Mon, 13 Apr 2009 05:35:02 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Subject: Re: [PATCH 56/56] xfs: Remove void casts
References: <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-56-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-57-git-send-email-jwjstone@fastmail.fm>
	<81C20178-5096-4E2E-A588-28AAE674748F@sgi.com>
	<20090413093232.GA14320@infradead.org>
In-Reply-To: <20090413093232.GA14320@infradead.org>
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
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Apr 09, 2009 at 12:37:08PM -0500, Felix Blyakher wrote:
>> On Apr 8, 2009, at 6:22 AM, Jack Stone wrote:
>>
>>> Remove uneeded void casts
>>>
>>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
>> See comments below.
> 
> Agree with the comments, als the subject line seems wrong, the patch
> doesn't remove void casts, but casts from a void pointer to a typed
> one which aren't nessecary.
> 
> Also please don't submit patches like this in a large series to the
> world but separately to the listed maintainer / mailinglist of each
> subsystem as there is no interdependency nor a general interest.

And what evil have I committed, to be cursed with being CC'd on every 
damn one of these things?

	Jeff




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
