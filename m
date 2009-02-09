Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n190S9JJ205664 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 18:28:10 -0600
Message-ID: <498F7861.6010109@sgi.com>
Date: Mon, 09 Feb 2009 11:27:13 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: IMPORTANT: XFS Documentation
References: <1231946704.3929.36.camel@localhost.localdomain>	<20090120160346.GJ17616@sgi.com>	<1232480744.23291.101.camel@localhost.localdomain>	<20090128202715.GR16689@sgi.com>	<1233175168.25011.155.camel@localhost.localdomain>	<20090204183603.GA26714@sgi.com>
	<4989F4C2.3030305@sgi.com> <20090205112906.GB11781@infradead.org>
	<498D8F18.3080903@thebarn.com>
In-Reply-To: <498D8F18.3080903@thebarn.com>
Reply-To: markgw@sgi.com
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Eric Sandeen <sandeen@redhat.com>, SGI Engineering Interfaces to Red Hat <redhat-interface@sgi.com>, Marizol Martinez <martinez@redhat.com>, Tony Ernst <tee@sgi.com>, George Beshers <gbeshers@sgi.com>, John Hesterberg <jh@sgi.com>, xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, Gary Hagensen <gwh@sgi.com>, Ric Wheeler <rwheeler@redhat.com>



Russell Cattelan wrote:
> Christoph Hellwig wrote:
> ...
>>> I've updated the copyrights in the doc sources and put them in a git tree:
>>>
>>>     git://oss.sgi.com/xfs/cmds/xfsdocs.git
>> Russell, can you add this to the list of repositories to be displayed on
>>
>>     http://oss.sgi.com/cgi-bin/gitweb.cgi
>
> or maybe we should just update the existing xfs-website tree?
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/xfs-website/.git;a=summary

Rus, I didn't know that tree existed - it now has incorrect copyright
notices for the doc sources. However, since it's ahead of ptools
(and has cvs imported history too), I'll clone it as a replacement
and then merge in the training docs with updated copyrights. It's easier
for SGI if the official tree is git://oss.sgi.com/xfs/cmds/xfsdocs.git
since the directory structure mirrors the internal ptools hierarchy,
along with the other xfs/cmds trees.

>> Talking about that any chance you could convert your cvsimport
>> repositories to bare repos like all the others on oss?  And maybe
>> move the old xfs-cmds import under cattelan/ like the other cvsimport
>> ones?
>>
> I moved cvsimported xfs-import dmapi-import and xfs-cmds under archive.

Thanks for that.

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
