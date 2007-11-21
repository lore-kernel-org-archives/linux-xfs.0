Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 08:09:07 -0800 (PST)
Received: from c3po.klbg.n.redcross.or.at (c3po.klbg.n.redcross.or.at [195.202.144.145])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lALG8db9016638
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 08:08:48 -0800
Message-ID: <47445130.5070103@strike.wu-wien.ac.at>
Date: Wed, 21 Nov 2007 16:39:28 +0100
From: "Alexander 'Leo' Bergolth" <leo@strike.wu-wien.ac.at>
MIME-Version: 1.0
Subject: Re: XFS crash on linux raid
References: <20070503164521.16efe075@harpe.intellique.com> <20070504005922.GC32602149@melbourne.sgi.com> <20070504090613.7c0f97d3@galadriel.home> <20070504073344.GL32602149@melbourne.sgi.com> <20070504152546.614374ac@harpe.intellique.com> <463B4962.70904@sandeen.net> <20070504173049.14606033@harpe.intellique.com> <20070504232028.GA19744@tuatara.stupidest.org> <4741D198.2060908@strike.wu-wien.ac.at> <20071119234415.GB29042@puku.stupidest.org>
In-Reply-To: <20071119234415.GB29042@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Emmanuel Florac <eflorac@intellique.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 11/20/2007 12:44 AM, Chris Wedgwood wrote:
> On Mon, Nov 19, 2007 at 07:10:32PM +0100, Alexander Bergolth wrote:
>> Several months ago, you posted a patch for 8k stacks together with
>> irqstacks:
 >
> I'll take a look.  Can you make sure it works with 8K stacks (more or
> less works).

It works (more or less) fine without the patch that splits irqstacks 
from 4k stacks. (I tried it both with CONFIG_4KSTACKS set and unset.)

Thanks,
--leo
-- 
e-mail   ::: Alexander.Bergolth (at) wu-wien.ac.at
fax      ::: +43-1-31336-906050
location ::: Computer Center | Vienna University of Economics | Austria
