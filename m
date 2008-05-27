Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 16:49:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4RNniXg028979
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 16:49:45 -0700
Subject: Re: xfs_check
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080527162605.GA30344@lst.de> <483C3B5C.3040407@sandeen.net> <20080527165049.GA20666@puku.stupidest.org> <483C3CFC.8040201@sandeen.net>
Content-Transfer-Encoding: 7bit
Date: Wed, 28 May 2008 09:50:40 +1000
Message-ID: <op.ubt66qhx3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <483C3CFC.8040201@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Chris Wedgwood <cw@f00f.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, 28 May 2008 02:55:24 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Chris Wedgwood wrote:
>> On Tue, May 27, 2008 at 11:48:28AM -0500, Eric Sandeen wrote:
>>
>>> xfs_check checks... $SOMETHING that xfs_repair still does not, I
>>> think?
>>
>> does that imply that that if $SOMETHING is bad it won't be seen then
>> repaired then?
>
> I can't remember what $SOMETHING is but I bet Barry knows :)

Free space btrees!

But I would be enhancing xfs_repair -n to actually check them.
