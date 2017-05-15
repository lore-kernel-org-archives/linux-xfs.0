Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54516 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933207AbdEOTaq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 May 2017 15:30:46 -0400
Subject: Re: [PATCH 1/9] xfs_io: support the new getfsmap ioctl
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <149417258268.24656.3441330396895207773.stgit@birch.djwong.org>
 <212fe5da-d589-1614-0980-ab583db1df5d@sandeen.net>
 <20170515191809.GO4519@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0871f178-9161-b5e6-100c-96c1f4c97e6c@sandeen.net>
Date: Mon, 15 May 2017 14:30:44 -0500
MIME-Version: 1.0
In-Reply-To: <20170515191809.GO4519@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org



On 5/15/17 2:18 PM, Darrick J. Wong wrote:
>> speakinawhich, I wonder how much of this is copied from bmap, and what could
>> be shared?
>>
>> I'm going to go off & look at that a bit, may have further comments.  :)
> Do you have further comments?

Not on this patch, I guess - I had thought that there was an inordinate amount
of cut & paste from bmap but at least a quick look didn't bear that out.

TBH haven't looked at the rest of the series yet, I keep getting sucked
into other things, sorry.

-Eric
