Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GIbZSx084451 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 13:37:45 -0500
Received: from ishtar.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BCFE1CC792E
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 11:36:58 -0700 (PDT)
Received: from ishtar.tlinx.org (ishtar.tlinx.org [64.81.245.74]) by
	cuda.sgi.com with ESMTP id asYDNezUQJqeVC4j for
	<xfs@oss.sgi.com>; Thu, 16 Apr 2009 11:36:58 -0700 (PDT)
Received: from [192.168.3.11] (Athena [192.168.3.11])
	by ishtar.tlinx.org (8.14.1/8.12.10/SuSE Linux 0.7) with ESMTP id
	n3GIauPP031817 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 11:36:56 -0700
Message-ID: <49E77ACA.9060301@tlinx.org>
Date: Thu, 16 Apr 2009 11:36:58 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: getting changes (fixes or enhancements) to xfs-tools
References: <49E65044.8080802@tlinx.org> <49E6B6F7.6030500@sandeen.net>
	<49E6ED88.5020008@tlinx.org> <49E746A0.5020008@sandeen.net>
In-Reply-To: <49E746A0.5020008@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Linda A. Walsh wrote:
>> I can understand that for kernel work, but what about the xfs utils? 
> Again, just look at the git logs.
> -Eric
----

    I understand you want people to see the work that has gone into the
kernel, but telling someone to search through 1327 entries just to find
an answer of 'no', seems a bit ...something.

     FWIW: I copied all 1327 entries to a text file and searched for
any string "xfs[a-z]" to search for any comments about utility changes.
Only strings found were for the daemons that are run.

     Now that I've determined that the xfs utils are not in the kernel
source tree (I wouldn't have expected them to be), maybe I can more
be less indirect and ask: Who is managing the the xfs_utils, Where are
they kept and What is the procedure for trying to get changes (fixes
or enhancements) to them?   (I prefer direct questioning, but too many
people, even in the engineering/sw community,  find it rude or abrupt,
so it's not usually my 1st choice).

In other words, does one:

(I) suggest new ideas and if the keeper(s) likes them, they are
     implemented and redistributed?
   OR
(II.1) suggest new ideas and see if keeper(s) approve of 'project' so
     one can then go and
     (i) implement the changes in a local version, and then?
     	(a) check them in?
           OR
         (b) submit for approval so they can be approved for
             inclusion (or fixing any found problems)
   OR
(III) just go off and implement the code, then come back and say, hey,
     here are my changes for this idea, and just expect to be greeted
     with open arms?  ;^/

---
(I hope I got the indentation and syntax correct in that, English
syntax isn't always the easiest language to express nested options
in...:-))

     I'm trying to get clear on process.  If they are in the kernel
tree, there may be no way for me to get from A->B, othewise, I'm
trying to find out where one might have hope of bouncing ideas that
might get implemented or that if sufficiently positively received
might spure someone to try implementing the changes themselves (and
possibly (and possibly get in completely over their head....or not.)

:-)
thanks!
-linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
