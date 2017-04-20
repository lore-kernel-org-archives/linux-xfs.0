Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47458 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032464AbdDTRsd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 13:48:33 -0400
Subject: Re: [PATCH] xfs_io: add missed inode command into man page
References: <1492708017-14163-1-git-send-email-zlang@redhat.com>
 <20170420172309.GD23371@birch.djwong.org>
 <15dca057-8757-8453-ddf9-7f7e394a8731@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f864cd01-3a9f-25da-be5f-f6bbf1cb52fd@sandeen.net>
Date: Thu, 20 Apr 2017 12:48:32 -0500
MIME-Version: 1.0
In-Reply-To: <15dca057-8757-8453-ddf9-7f7e394a8731@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org


On 4/20/17 12:45 PM, Eric Sandeen wrote:
> On 4/20/17 12:23 PM, Darrick J. Wong wrote:
>> On Fri, Apr 21, 2017 at 01:06:57AM +0800, Zorro Lang wrote:
>>> There's an "inode" command in xfs_io, it's used to query physical
>>> information about an inode. But there's not any information about
>>> it in xfs_io and other related man pages. So document this command
>>> in the xfs_io man page now.

Oh, I would also put this in the "other commands" section, not the
"file I/O" section.

-Eric
