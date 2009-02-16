Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1G0FvMx105244 for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 18:15:57 -0600
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EFC519412EB
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 16:15:22 -0800 (PST)
Received: from ti-out-0910.google.com (ti-out-0910.google.com
	[209.85.142.189]) by cuda.sgi.com with ESMTP id
	BhEqRFI3CtEjAsAR for <xfs@oss.sgi.com>;
	Sun, 15 Feb 2009 16:15:22 -0800 (PST)
Received: by ti-out-0910.google.com with SMTP id a6so1501812tib.18
	for <xfs@oss.sgi.com>; Sun, 15 Feb 2009 16:15:21 -0800 (PST)
Message-ID: <4998AE71.2040304@gmail.com>
Date: Mon, 16 Feb 2009 11:08:17 +1100
From: Mark Goodwin <goodwinos@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH, needs a new owner] XFS Alloc Policies
References: <49939F90.20905@sgi.com> <20090212185853.GA23056@infradead.org>
In-Reply-To: <20090212185853.GA23056@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Feb 12, 2009 at 03:03:28PM +1100, Mark Goodwin wrote:
>> Series of patches, originally by Dave Chinner. This series
>> of 18 patches is unfinished and needs a new owner - the
>> feature partially implements pluggable allocation policies
>> for XFS.
>>
>> A fairly substantial architectural write-up with community
>> debate/feedback on the design would be appropriate before
>> embarking on this. Tarball attached for the following:
> 
> Thanks for posting these.  I'm pretty sure these patches will
> get some sort of makeover before beeing ready, but they are
> an important building block for some of the interesting work
> we're planning to do (like the multi device work or ssd-aware
> allocators), so there will be some action on it.
> 

Yep. It would be good if there was some kind of write-up on
those plans since the feature will be fairly intrusive. I assume
it's been a back-of-the-envelope-with-beer kind of discussion
so far ..

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
