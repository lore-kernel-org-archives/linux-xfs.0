Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A4CD7F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 16:24:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDE7DAC002
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 14:24:21 -0700 (PDT)
Received: from tetsuo.zabbo.net (tetsuo.zabbo.net [50.193.208.193]) by
	cuda.sgi.com with ESMTP id kIrimkCfq4zbIgrB for
	<xfs@oss.sgi.com>; Thu, 18 Sep 2014 14:24:18 -0700 (PDT)
Date: Thu, 18 Sep 2014 14:24:17 -0700
From: Zach Brown <zab@zabbo.net>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140918212417.GF16677@lenny.home.zabbo.net>
References: <20140918195650.GI19952@sgi.com>
 <20140918211010.GB4482@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918211010.GB4482@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Thu, Sep 18, 2014 at 04:10:10PM -0500, Ben Myers wrote:
> Hi,
> 
> On Thu, Sep 18, 2014 at 02:56:50PM -0500, Ben Myers wrote:
> > I'm posting this RFC for Unicode support in XFS on Olaf's behalf, as he
> > is busy with other projects.
> 
> Patch 7 of each series is the trie generator and utf8 normalization
> module.  Either it's just a little slow or it's over the message size
> limit on vger at a little over 100k.

Probably, yeah:

http://vger.kernel.org/majordomo-info.html

"
  * Message size exceeding 100 000 characters causes blocking.
"

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
