Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D01E57F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 16:10:13 -0500 (CDT)
Date: Thu, 18 Sep 2014 16:10:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140918211010.GB4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918195650.GI19952@sgi.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

Hi,

On Thu, Sep 18, 2014 at 02:56:50PM -0500, Ben Myers wrote:
> I'm posting this RFC for Unicode support in XFS on Olaf's behalf, as he
> is busy with other projects.

Patch 7 of each series is the trie generator and utf8 normalization
module.  Either it's just a little slow or it's over the message size
limit on vger at a little over 100k.  In case it's the latter I've
placed them here:

ftp://oss.sgi.com/projects/xfs/tmp/18-Sep-14/0007-xfs-add-trie-generator-and-supporting-code-for-UTF-8.patch
and 
ftp://oss.sgi.com/projects/xfs/tmp/18-Sep-14/0007-libxfs-add-trie-generator-and-supporting-code-for-UT.patch

I'll give it a while and then see about splitting up the patch.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
