Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAGJLgTr106073 for <xfs@oss.sgi.com>; Tue, 16 Nov 2010 13:21:42 -0600
Subject: Re: [PATCH v3 0/9] xfsrestore dirent limitations and scaling issues
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101116150502.179825893@sgi.com>
References: <20101116150502.179825893@sgi.com>
Date: Tue, 16 Nov 2010 13:21:55 -0600
Message-ID: <1289935315.1950.91.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, 2010-11-16 at 09:05 -0600, wkendall@sgi.com wrote:
> v3 of this series reworks a couple of the patches based on feedback
> from Alex Elder:
> 
> - 3rd patch: changed a buffer size check to an assert.
> - 7th patch: move static functions up in the file and
>   create typedefs for segix_t and relnix_t.
> 
> The remainder is unchanged from the previous submission.

I'm shepherd this series in to the xfsdump-dev tree
for Bill.  I'll wait until tomorrow though, to give
others one more chance to review.  If anyone has any
objection please say so.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
