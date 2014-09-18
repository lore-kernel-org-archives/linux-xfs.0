Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E5ED7F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 17:23:52 -0500 (CDT)
Date: Thu, 18 Sep 2014 17:23:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140918222348.GC4482@sgi.com>
References: <20140918195650.GI19952@sgi.com> <20140918211010.GB4482@sgi.com>
	<20140918212417.GF16677@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918212417.GF16677@lenny.home.zabbo.net>
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
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Thu, Sep 18, 2014 at 02:24:17PM -0700, Zach Brown wrote:
> On Thu, Sep 18, 2014 at 04:10:10PM -0500, Ben Myers wrote:
> > On Thu, Sep 18, 2014 at 02:56:50PM -0500, Ben Myers wrote:
> > > I'm posting this RFC for Unicode support in XFS on Olaf's behalf, as he
> > > is busy with other projects.
> > 
> > Patch 7 of each series is the trie generator and utf8 normalization
> > module.  Either it's just a little slow or it's over the message size
> > limit on vger at a little over 100k.
> 
> Probably, yeah:
> 
> http://vger.kernel.org/majordomo-info.html
> 
> "
>   * Message size exceeding 100 000 characters causes blocking.
> "

D'oh!  I'll split it up.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
