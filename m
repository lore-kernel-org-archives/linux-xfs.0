Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E50747FAD
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 04:37:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C31468F8049
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 02:37:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wPPFq6W64OnwY8he for
	<xfs@oss.sgi.com>; Tue, 05 Nov 2013 02:37:19 -0800 (PST)
Message-ID: <5278CA40.8080609@redhat.com>
Date: Tue, 05 Nov 2013 11:36:48 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
References: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
	<20120613013549.GO22848@dastard>
	<20120613033052.GT22848@dastard> <4FD82F89.80106@redhat.com>
	<20131105103435.GA24387@infradead.org>
In-Reply-To: <20131105103435.GA24387@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

Il 05/11/2013 11:34, Christoph Hellwig ha scritto:
> On Wed, Jun 13, 2012 at 08:13:29AM +0200, Paolo Bonzini wrote:
>> Sure.  Thanks for the hints, I'll submit a v2 (may take a while as I'll
>> leave for holiday soon).
> 
> Did you ever get back to this?

I have some patches for both kernel and xfstests, but I never got round
to testing them properly.  I don't think I'll have time soon to finish
that, but I might coerce someone into doing it.

Paolo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
