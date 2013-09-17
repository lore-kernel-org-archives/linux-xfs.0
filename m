Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E8DE7F63
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 16:11:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F28B730404E
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 14:11:19 -0700 (PDT)
Message-ID: <5238C575.4000900@redhat.com>
Date: Tue, 17 Sep 2013 16:11:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: check for valid input to _scratch_mkfs_sized
References: <5238ADE1.5050204@redhat.com> <5238BE63.8000405@sgi.com>
In-Reply-To: <5238BE63.8000405@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 9/17/13 3:41 PM, Mark Tinguely wrote:
> On 09/17/13 14:30, Eric Sandeen wrote:
>> _scratch_mkfs_sized requires an integer number of bytes
>> as input; if it's given something else, catch it and _notrun.
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
> 
> Ah, the "don't do what Mark did" patch.

the "make life easier for future Marks" patch.  ;)

> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
