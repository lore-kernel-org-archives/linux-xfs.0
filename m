Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32B9329DF8
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:35:26 -0500 (CDT)
Date: Tue, 11 Jun 2013 14:35:25 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Questions about XFS
Message-ID: <20130611193525.GT20932@sgi.com>
References: <loom.20130611T112155-970@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20130611T112155-970@post.gmane.org>
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
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-xfs@oss.sgi.com

Hey Steve,

On Tue, Jun 11, 2013 at 09:56:38AM +0000, Steve Bergman wrote:
> I have a few questions about XFS that didn't make the XFS FAQ. I'm trying to
> get a feel for where I might want to use it on my servers (or at home). A mix
> of ext3 & ext4 has worked well for me. But I'd like to get to know XFS a bit
> better. The target OS would be RHEL6.

"If it ain't broke don't fix it."

It's good that you look before you jump.

> 9. I there something else I should have thought to ask?

* How do I back it up?

I'm always surprised at how many people neglect backups and then run into
trouble.  xfsdump is the preferred method.

* Where can I learn more?

http://www.xfs.org/index.php/XFS_Papers_and_Documentation

The user guide link is a good place to get started.

My personal favorite link on this page is to the original design
documents from '93 (at the bottom).  If you ever have a 'why the heck
did they do it this way' moment with XFS, this is the place to go.

Not the least of the arguments in favor of using XFS is that we have a
rich and active community.  You can also get professional support from a
variety of vendors.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
