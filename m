Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 02F467F59
	for <xfs@oss.sgi.com>; Sat,  8 Nov 2014 18:09:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E406C8F8033
	for <xfs@oss.sgi.com>; Sat,  8 Nov 2014 16:09:17 -0800 (PST)
Received: from gproxy6-pub.mail.unifiedlayer.com
	(gproxy6-pub.mail.unifiedlayer.com [67.222.39.168]) by
	cuda.sgi.com with SMTP id CFxKZ8Ladh5rL2Jh for
	<xfs@oss.sgi.com>; Sat, 08 Nov 2014 16:09:12 -0800 (PST)
Date: Sun, 09 Nov 2014 00:08:57 +0000
Message-ID: <20141109000857.Horde.Tr45nuj-d1SIP9KtnXGR5Q1@just41.justhost.com>
From: cem@maiolino.org
Subject: Re: beginners project: RENAME_WHITEOUT
References: <20141107190959.GB21021@infradead.org>
	<545D4EE5.6040901@sandeen.net> <20141108064033.GA3450@infradead.org>
In-Reply-To: <20141108064033.GA3450@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


Quoting Christoph Hellwig <hch@infradead.org>:

> On Fri, Nov 07, 2014 at 04:59:49PM -0600, Eric Sandeen wrote:
>> On 11/7/14 1:09 PM, Christoph Hellwig wrote:
>> > The overlayfs merge introduces a new rename flag to create to whiteouts.
>> > Should be a fairly easy to implement.
>> >
>> > Miklos, do you have any good documentation and/or test cases for this?
>>
>> FWIW, Carlos just expressed some interest today in doing this, and it
>> builds on his earlier patches, yes?
>
> It's in the same area, but not otherwise related.  But I'd be happy if
> he picks it up.

consider it picked up..


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
