Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 566987F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 02:12:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5750AC006
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 00:12:00 -0700 (PDT)
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2]) by
	cuda.sgi.com with ESMTP id I94Q4Xyhv1TpOaKr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 00:11:55 -0700 (PDT)
From: Victor Stinner <victor.stinner@enovance.com>
Subject: Re: Can you help me to investiage a soft lockup?
Date: Thu, 09 Oct 2014 09:11:52 +0200
Message-ID: <1673046.E2St3OFZUd@smithers>
In-Reply-To: <20141008212346.GS2301@dastard>
References: <1211918248.8179166.1412774638265.JavaMail.zimbra@enovance.com>
	<734140413.8186921.1412777666412.JavaMail.zimbra@enovance.com>
	<20141008212346.GS2301@dastard>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

On Thursday 09 October 2014 08:23:46 Dave Chinner wrote:
> You best bet would be to upgrade to a more recent kernel rather than
> try to indentify and backport a bunch of fixes to an old kernel...

I don't know the Linux kernel enough to feel confident to backport changes. So 
upgrading is the safest option. Eric Sandeen gave me the same advice. We will 
try to upgrade to Linux 3.13.

Thanks for your reply.

Victor

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
